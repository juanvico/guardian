var amqp = require('amqplib/callback_api');
const ErrorService = require('../services/error-service');
const UserService = require('../services/user-service');

const topics = [
  'users_add',
  'errors_add'
];

const rabbitURL = 'amqp://user:password@rabbitmq:5672/'

const startListeningQueues = () => {
  console.log('Connecting Billing to RabbitMQ')
  amqp.connect(rabbitURL, function (error0, connection) {
    try {
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
            console.log(`New Message: topic = ${msg.fields.routingKey}, body: ${msg.content.toString()}`)
            const contentBody = JSON.parse(msg.content.toString());
            topicHandler[`${msg.fields.routingKey}`](contentBody)
          }, {
            noAck: true
          });
        });
      });
    } catch (error) {
      console.log('Error: ', error);
      console.log('Retry reconnection in 5 seconds ... ');
      setTimeout(() => {
        startListeningQueues();
      }, 10000)
    }
  });
};

const topicHandler = {
  'errors_add': ({ organization_id: orgId }) => ErrorService.updateOrganizationErrors(orgId),
  'users_add': ({ organization_id: orgId }) => UserService.updateOrganizationUsers(orgId)
};

module.exports = { startListeningQueues };
