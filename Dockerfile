FROM python:3.7-alpine
LABEL maintainer="Frantz Paul"

# don't buffer output
# print it directly
# recommended with 
# python on docker
ENV PYTHONUNBUFFERED 1 

COPY ./requirements.txt /requirements.txt

# install postgresql client
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
     gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# -D is user only for running application
# for security reasons. Root user is not going
# to be used.
RUN adduser -D user
USER user
