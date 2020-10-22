# Guardian

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

### Production URL

https://guardian-prod-arqui-obli.tk/

### Credentials

In order to test the system functionality you can use the following credentials

- Role: `ADMIN`
- User: `arquitectura@ort.com.uy`
- Password: `123456789123`

### Deploy

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 198739960305.dkr.ecr.us-east-1.amazonaws.com
```

```bash
docker build -t guardian .
```

```bash
docker tag guardian:latest 198739960305.dkr.ecr.us-east-1.amazonaws.com/guardian:latest
```

```bash
docker push 198739960305.dkr.ecr.us-east-1.amazonaws.com/guardian:latest
```

Go to AWS ECS, click on the `guardian-prod` cluster. Update `guardian-prod-service` and click on "Force Deploy".
