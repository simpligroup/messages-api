from fastapi import FastAPI, Response, status, HTTPException
from pydantic import BaseModel
from pymongo import MongoClient, ReturnDocument
from typing import List
from uuid import UUID, uuid4
import os
import re


# Core
class Channel(BaseModel):
    id: str
    name: str


class Service(BaseModel):
    id: str
    name: str
    hostName: str
    endpoint: str


class Consumer(BaseModel):
    id: str
    name: str
    services: List[Service]


class ChannelConflictException(Exception):
    "Existing channel with some of this attributes"
    pass


class ConsumerConflictException(Exception):
    "Existing channel with some of this attributes"
    pass


# Infra

client = MongoClient(os.getenv("MONGODB_URL", "Nothing was set"))
db = client[os.getenv("MONGO_INITDB_DATABASE", "Nothing was set")]
channel_collection = db["channels"]
consumer_collection = db["consumers"]


class ChannelRepository:
    def create_channel(self, channel: Channel):
        existing_channel = channel_collection.find_one({"id": channel.id})
        if existing_channel:
            raise ChannelConflictException()
        channel_collection.insert_one(channel.model_dump())

    def find_channel_by_name(self, channel_name: str):
        return channel_collection.find_one({"name": channel_name})


class ConsumerRepository:
    def update_consumer(self, consumer: Consumer):
        return consumer_collection.find_one_and_update(
            {"id": consumer.id, "name": consumer.name},
            {"$set": consumer.model_dump()},
            return_document=ReturnDocument.AFTER,
        )

    def create_consumer(self, consumer: Consumer):
        existing_consumer = consumer_collection.find_one({"id": consumer.id})
        if existing_consumer:
            raise ConsumerConflictException()

        consumer_collection.insert_one(consumer.model_dump())

    def find_consumer_by_name(self, consumer_name: str):
        return consumer_collection.find_one({"name": consumer_name})


# Controller

app = FastAPI()

channel_repository = ChannelRepository()
consumer_repository = ConsumerRepository()


@app.put("/channels/{channel_id}")
def read_item(channel_id: str, channel: Channel, response: Response):
    # Validations
    channel_name_regex = r"^[a-z0-9]+(?:-[a-z0-9]+)*$"
    if channel.id != channel_id or re.search(channel_name_regex, channel.name) is None:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail="Ids do not match"
        )

    try:
        existing_channel = channel_repository.find_channel_by_name(channel.name)

        if existing_channel is None:
            channel_repository.create_channel(channel)
            response.status_code = status.HTTP_201_CREATED
            return None

        if existing_channel["id"] == channel.id:
            response.status_code = status.HTTP_200_OK
            return None

        raise ChannelConflictException()

    except ChannelConflictException as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))
    except Exception as e:
        print(e)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.put("/consumers/{consumer_id}")
def read_item(consumer_id: str, consumer: Consumer, response: Response):
    # Validations
    names_regex = r"^[a-z0-9]+(?:-[a-z0-9]+)*$"
    if (
        consumer.id != consumer_id
        or re.search(names_regex, consumer.name) is None
        or (consumer.services is None or len(consumer.services) == 0)
    ):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail="Ids do not match"
        )
    for services in consumer.services:
        if re.search(names_regex, services.name) is None:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail="Ids do not match",
            )

    try:
        existing_consumer = consumer_repository.find_consumer_by_name(consumer.name)

        if existing_consumer is None:
            consumer_repository.create_consumer(consumer)
            response.status_code = status.HTTP_201_CREATED
            return None

        if existing_consumer["id"] == consumer.id:
            consumer_updater = consumer_repository.update_consumer(consumer)
            if consumer_updater:
                response.status_code = status.HTTP_200_OK
                return None
            raise Exception("Non updated consumer")

        raise ConsumerConflictException()

    except ConsumerConflictException as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))
    except Exception as e:
        print(e)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
