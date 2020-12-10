var amqp = require('amqplib/callback_api');
const ErrorController = require('../controllers/error-controller');
const UserController = require('../controllers/user-controller');;

const topics = [
  'create_error',
  'update_error',
  'resolve_error',
  'create_user',
  'update_user',
  'configure_user',
];

const startListeningQueues = () => {
  amqp.connect({
    host: "localhost",
    port: 5672,
    virtual_host: "/",
    username: "user",
    password: "password",
    name: "rabbitmq",
  }, function (error0, connection) {
    if (error0) {
      throw error0;
    }
    connection.createChannel(function (error1, channel) {
      if (error1) {
        throw error1;
      }
      var exchange = 'topics_guardian';
      console.log('connected')
      channel.assertExchange(exchange, 'topic', {
        durable: false
      });

      channel.assertQueue('', {
        exclusive: true
      }, function (error2, q) {
        if (error2) {
          throw error2;
        }

        topics.forEach(function (key) {
          channel.bindQueue(q.queue, exchange, key);
        });

        channel.consume(q.queue, function (msg) {
          const contentBody = JSON.parse(msg.content.toString());
          topicHandler[`${msg.fields.routingKey}`](contentBody)
        }, {
          noAck: true
        });
      });
    });
  });
};

const topicHandler = {
  'create_error': ErrorController.onErrorAdded,
  'update_error': ErrorController.onErrorUpdated,
  'resolve_error': ErrorController.onErrorResolved,
  'create_user': UserController.onUserAdded,
  'update_user': UserController.onUserUpdated,
  'configure_user': UserController.onConfigurationUpdated,
};

module.exports = { startListeningQueues };
