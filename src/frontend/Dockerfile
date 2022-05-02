FROM python:3.9-slim
COPY ./frontend.py /frontend/frontend.py
COPY ./requirements.txt /frontend/requirements.txt
WORKDIR /frontend
RUN pip install --upgrade pip setuptools wheel
RUN pip install --default-timeout=100 -r requirements.txt --no-cache-dir
EXPOSE 80
ENTRYPOINT [ "python3", "frontend.py" ]
