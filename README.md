# Introduction
This project, whose starting point was the [flask-redis](https://github.com/docker/awesome-compose/tree/master/flask-redis) repository, is used as an educational material to teach and demonstrate in practice the following topics:

- The main traits and benefits of a [fault-tolerant](https://www.okta.com/identity-101/fault-tolerance/) application.
- The advantages of using containers to ship products.
- The benefits of using an AI pair programming technique with GitHub Copilot via IDE.
- Introduction to the [Circuit Breaker](https://microservices.io/patterns/reliability/circuit-breaker.html) pattern.
- Basics of the following technologies:
    - Flask based RESTful service
    - Redis database
    - [Docker ecosystem](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/container-docker-introduction/)
- How to utilize [GitHub Dependabot](https://github.com/skills/secure-repository-supply-chain) to receive notifications and pull requests regarding version updates and vulnerabilities. 
- How to create an effective visualization of actions inside a terminal window using the [Terminalizer](https://www.terminalizer.com) tool.

# Setup
You must create the `.env` file (inside the root project folder) having the following structure:
```
NAME=<insert any text here>
```
# Demostration of a Fault-Tolerant Behavior
You should run the commands below from the root folder of this project.

| Step                             | Description |
|----------------------------------| ----------- |
| `docker compose up -d`           | Start up the application stack in the background. |
| `docker compose ps`              | List running containers of this stack. |
| `docker compose exec web id`     | Show that the web service is running under a non-root user. |
| `docker compose logs`            | Show generated logs inside running containers <br/>(option `-f` may be used to follow the logs). |
| `docker compose port web 8080`   | Display the port on host that is mapped to port 8080 inside a web container. |
| `curl localhost:"port on host"`  | Execute couple of times this command on host to see the application in action. |
| `docker compose pause redis`     | Pause the database to simulate a connectivity problem. |
| `curl localhost:"port on host"`  | Execute couple of times this command on host to see fault-tolerance in action. <br/>Observe that the first attempt takes a bit longer to run, <br/>since the circuit breaker waits for a timeout to happen on a socket. <br/>Subsequent requests immediately fail. <br/>Occasionally the circuit will try to close again and that also demands waiting for a timeout. |
| `docker compose unpause redis`   | Unpause the database to simulate that everything is OK again. |
| `curl localhost:"port on host"`  | Execute couple of times this command on host to verify that everything fully works. |
| `docker compose down`            | Stop the application stack. | 

![Demo Steps](./demo-steps.gif)
> Hint: Click on the image to watch it enlarged. 
## Monitoring Redis Keys
Open a new terminal window positioned in the same project folder and run `docker compose exec redis redis-cli`. Execute the `monitor` command and watch what happens inside the database.
```
127.0.0.1:6379> monitor
OK
1702666552.931740 [0 172.28.0.3:55674] "HELLO" "3"
1702666552.932190 [0 172.28.0.3:55674] "CLIENT" "SETINFO" "LIB-NAME" "redis-py"
1702666552.932670 [0 172.28.0.3:55674] "CLIENT" "SETINFO" "LIB-VER" "5.0.1"
1702666552.933153 [0 172.28.0.3:55674] "INCRBY" "visits" "1"
1702666554.167246 [0 172.28.0.3:55674] "INCRBY" "visits" "1"
```

# Conclusion
A distibuted system must incorporate some form of fault-tolerance, since many things may go wrong during its operation. This project sheds light on the essential idea pertaining to tolerating fault by providing a limited functionality instead of completely failing with an error message. There are numerous patterns available for building resilient applications, _circuit breaker_ being one of them, which was presented here.
