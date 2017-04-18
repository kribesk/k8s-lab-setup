
## Packing application with docker

_(Section by Boris Kirikov)_

Packing application into docker image is easy. `docker build` command reads `Dockerfile` as a guide and creates image. This means some
image is taken as a base and layer with application files is added as a new layer.

Syntax: `docker build -t <image> .` builds image using Dockerfile in current directory.

After that `docker run --name <container> <image>` can be used to start the app.


### Dockerfile

File consist of lines with instructions. Each line looks like `<INSTRUCTION> <arguments>`.

Basic instructions [@docker-dockerfile]:

  * `FROM <image>` use image as base
  * `RUN <command>` run command in shell while building
  * `CMD <command>` defines how to run container
  * `LABEL <key>=<value>` adds label to image
  * `EXPOSE <port>` exposes port
  * `ENV <key>=<value>` set environment variable
  * `COPY <src> <dst>` copy file to container
  * `USER <user>` switches to user
  * `WORKDIR <path>` sets working directory

### Example

Let's create hello world web server using python.

  1. `mkdir hello-world && cd hello-world`
  2. `cat > app.py` this [@bottle]:

~~~~~
from bottle import route, run

@route('/')
def index():
  return 'ok'

run(host='0.0.0.0', port=13579)
~~~~~

  3. `cat > Dockerfile` this:

~~~~~
FROM alpine:latest

COPY app.py /src/app.py

RUN apk add --update python py-pip
RUN pip install bottle

EXPOSE  13579
CMD python /src/app.py
~~~~~

  4. Now build: `docker build -t hello-world .`
  5. And run: `docker run --name hello-world-1 -p 13579:13579 -i -t hello-world`
  6. Browse to `http://localhost:13579/`

