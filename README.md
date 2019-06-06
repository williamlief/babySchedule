# Baby Schedule
This is a simple program that parses text messages and turns them into a graph. We get daily messages from our childcare provider that list when she ate, when her diaper was changed, and her naps. This code pulls the messages from the imessage sql database on my laptop, parses them, and then creates a graph. I made a shiny app as an interface so we can visualize the data and see how her schedule is changing over time. 

You can see the shiny app here. 

Note: I am not exposing my baby's schedule to the internet. The hosted app is run with fake data.  

TODO: Create fake data and host webapp with fake data

# Example Message

This is an example of a text message we would receive. I wanted to make this program have zero implementation burden for our childcare providers and didn't ask them to change how they were sending the info to us. I was lucky that they were pretty consistent in how they wrote the text messages. 

---
**example message**

Baby1 nap 8-9  
Baby2 nap 8:10-10  
Baby1 diaper change 9:15  
Baby1 bottle 9:30  
Baby2 bottle 10:00  
baby2 poo 10:10

---


