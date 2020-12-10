var amqp = require('amqplib/callback_api');
const ErrorService = require('../services/error-service');

const topics = [
  'users_add',
  'errors_add'
]

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
}

const topicHandler = {
  'errors_add': ({ org_id: orgId }) => ErrorService.updateOrganizationErrors(orgId)
}

module.exports = { startListeningQueues };