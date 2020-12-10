# Guardian

> An error hunting service.

> Install `docker-compose`. [Installation](https://docs.docker.com/compose/install/)

## Running

### Setup Billing

Go to `billing` service

```
cd billing
```

Create .env file with the following structure

```
DB_URI="mongodb://mongo:27017/billing"
SERVER_KEY="Mun42ucruSYwglR68Ec9JF71UpgnrhvbwRA7XUZzU_9JxeI7UEi-cZ6dsG7A8mERpgoFZmDTnelpB5zNw2ATyQ"
```

### Setup Notifications

Go to `notifications` service

```
cd notifications
```

Create .env file with the following structure

```
DB_URI=mongodb://mongo:27017/guardian_notifications
EMAIL_FROM=juanandresvico@hotmail.com
SENDGRID_API_KEY=
SERVER_KEY="Mun42ucruSYwglR68Ec9JF71UpgnrhvbwRA7XUZzU_9JxeI7UEi-cZ6dsG7A8mERpgoFZmDTnelpB5zNw2ATyQ"
```

### Setup Statistics

Go to `statistics` service

```
cd statistics
```

Create .env file with the following structure

```
DB_URI="mongodb://mongo:27017/statistics"
SERVER_KEY="Mun42ucruSYwglR68Ec9JF71UpgnrhvbwRA7XUZzU_9JxeI7UEi-cZ6dsG7A8mERpgoFZmDTnelpB5zNw2ATyQ"
```

# IMPORTANT!!

Note that the in `DB_URI` the host needs to be the same as the service at the `docker-compose.yml` file.
In this case we have `mongo` as the name:

```
services:
  mongo:
    image: mongo
    restart: always
    ports:
      - '27017:27017'
```

And also, `SERVER_KEY` needs to be the same as in `SERVER_KEY: 'Mun42ucruSYwglR68Ec9JF71UpgnrhvbwRA7XUZzU_9JxeI7UEi-cZ6dsG7A8mERpgoFZmDTnelpB5zNw2ATyQ'`
inside `docker-compose.yml` file

### Build & Start

Go to root directory. And run the following commands:

```
docker-compose build

docker-compose run
```
