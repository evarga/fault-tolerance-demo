import os
import socket
from flask import Flask
from redis import Redis
from pybreaker import CircuitBreaker, CircuitBreakerError

db = Redis(host="redis", db=0, socket_timeout=2, protocol=3)
db_breaker = CircuitBreaker(fail_max=1, reset_timeout=5)
app = Flask(__name__)


# If the dabatase is not available, then the circuit will become open.
# Subsequent calls will immediatelly fail instead of being redirected
# toward a database. The circuit will periodically try to close according
# to the configuration parameters (see above). A close state means
# that the annotated function again executes without problems.
@db_breaker
def num_visits():
    return db.incr('visits')


@app.route("/")
def hello():
    try:
        visits = num_visits()
    except CircuitBreakerError:
        visits = "<em>The counter is temporarily disabled!</em>"

    response = \
        """
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <title>Fault Tolerance Demo</title>
            </head>
            <body>
                <h1>Hello {name}!</h1>
                <strong>Hostname:</strong> {hostname}<br/>
                <strong>Visits:</strong> {visits}
            </body>
        </html>
        """
    return response.format(name=os.getenv("NAME"), hostname=socket.gethostname(), visits=visits)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
