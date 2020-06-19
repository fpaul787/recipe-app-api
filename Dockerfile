FROM python:3.7-alpine
LABEL maintainer="Frantz Paul"

# don't buffer output
# print it directly
# recommended with 
# python on docker
ENV PYTHONUNBUFFERED 1 

COPY ./requirements.txt /requirements.txt

# install postgresql client
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
     gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev

RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
# -D is user only for running application
# for security reasons. Root user is not going
# to be used.
RUN adduser -D user

#change owner of /vol directory
RUN chown -R user:user /vol

# change permissions
RUN chmod -R 755 /vol/web
USER user
