FROM python:3.9-alpine

WORKDIR /app

COPY src/. .
RUN pip install -rrequirements.txt

EXPOSE 5000

ENTRYPOINT ["python"]

CMD [ "main.py" ]
