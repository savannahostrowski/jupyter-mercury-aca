FROM python:3.9
WORKDIR /code
EXPOSE 8000
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./src /code

CMD ["mercury", "run", "0.0.0.0:8000"]