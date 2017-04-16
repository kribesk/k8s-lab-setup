
## Deploying docker container to kubernetes

_(Section by Volodymyr Lubenets)_

This is an example of deploying the service to kubernetes cluster.
Let's suppose the cluster is already up and running.

Other than that, suppose we have small python application, which acts as a HTTP server, as such.
**app.py**

    #!/usr/bin/python
    from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
    
    PORT_NUMBER = 8080

    #This class will handles any incoming request from
    #the browser 
    class myHandler(BaseHTTPRequestHandler):
    	
    #Handler for the GET requests
    def do_GET(self):
    	self.send_response(200)
    	self.send_header('Content-type','text/html')
    	self.end_headers()
    	# Send the html message
    	self.wfile.write("Hello World !")
    	return
    
    #Create a web server and define the handler to manage the
    #incoming request
    server = HTTPServer(('', PORT_NUMBER), myHandler)
    
    #Wait forever for incoming http requests
    server.serve_forever()
    	

### Building docker container

The first thing to do is to write the provisioning script called Dockerfile. It contains the info on container's base system, files to be inserted and 
commands to be executed. In here, the listing is such:

**Dockerfile**

    FROM alpine:3.1
    
    COPY app.py /src/app.py
        
    RUN apk add --update python py-pip
    
    EXPOSE  13579
    CMD ["python", "/src/app.py"]

After this, execute the following commands:

    docker build -t smallapp .
    docker run --name smallapp -1 -p 8080:13579 -i -t smallapp

### Deploying docker image to minikube

Run `.\minikube.exe docker-env | Invoke-Expression` (for powershell) to switch to minikube's docker

Then run `kubectl apply -f local-registry.yml`