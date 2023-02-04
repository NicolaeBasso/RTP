### 0. Environment

*First thing you'll need to do is install your environment.*

**Task** Follow an installation guide to install the language / development environment of choice. 

https://www.erlang.org/downloads
https://elixir-lang.org/install.html
https://www.scala-lang.org/download
https://doc.akka.io/docs/akka/2.3/intro/getting-started.html

### 1. Hello PTR my old friend

*Proceed by checking if everything is installed correctly.*

**Task** Open the execution environment / command prompt. Write a command that would print the message "Hello PTR" on the screen. Execute it.

**Task** Write a script that would print the message "Hello PTR" on the screen. Execute it.

**Task** Write a script that would print a list containing the strings "Hello" and "PTR" on the screen. Execute it.

### 2. An actor is born

*Next, you'll need to create a process / actor which can receive messages and react to them.*

**Task** Create a module that defines an actor. Each time the actor receives a message, it should print it out. To test this, execute your module then start your actor. Open another execution environment / command prompt and send a message to the actor.

**Task** Define an actor that would store messages it receives into a list and would print out the list every time it receives an actor. Test similarly to the previous task.

**Task** Define an actor that would echo messages it receives back to the sender. Test similarly to the previous tasks.

### 3. You had 3 jobs..

*Every Message Broker needs to be able to do 3 tasks:*

- *To receive Subscribe messages*
- *To receive Publish messages*
- *To Send messages that are published to those who subscribed*

**Task** Create an actor. Whenever a Subscribe message is received, save the senders address into a list. Test this functionality.
**Task** Continue the previous task. Each time a Publish message is received, echo the message to the addresses contained in the subscribe list. Test this functionality.
**Final Task** Start your actor and 3 command prompts. Subscribe 1 of them to the actor. Use another prompt to Publish some messages. Now, Subscribe the last prompt. Use the publisher to Publish a couple more messages. Congratulations, you now have an actor-based message broker.

### Future work

*What remains are the following features:*

- *A Consumer should be able to unsubscribe;*
- *A producer / consumer should be able to specify a topic to Produce / Subscribe to.*