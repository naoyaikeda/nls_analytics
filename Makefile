USER=nikeda
NAME=nls_analytics
VERSION=0.0.8

build:
	docker build -t $(USER)/$(NAME):$(VERSION) .

restart: stop start

start:
	docker run -itd --rm \
		-p 10000:8888 \
		-p 54321:54321 \
		-v $$PWD/jovyan:/home/jovyan \
		--name $(NAME) \
		$(USER)/$(NAME):$(VERSION)

stop:
	docker stop $(NAME)

set-passwd:
	docker exec -it $(NAME) jupyter notebook password
