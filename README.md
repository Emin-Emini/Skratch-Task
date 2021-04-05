# Skratch Task

## Overview
[Description](Description)

[Random User API](Random-User-API)

[Work Process](Work-Process)

[Architecture](Architecture)

[Conclusion](Conclusion)

## Description
**This project is created as an interview task assigned from Skratch.**

The task is to create an app that will fetch a list of users from <a href="https://randomuser.me/">Random User</a>. You have to select the number of users to be fetched on your app. Then, those users will be presented on `TableView` and `Map`.
For using map, it's required to use third-party map <a href="https://www.mapbox.com">Mapbox</a>

As Design reference, there is a design provided by **Skratch** designed on <a href="https://www.figma.com/file/74Xvu3tfj3sJva6NfTtIg4/Friend-List-Task ">Figma</a>. 

Here’s what we would like to see:<br>
• Fetched users should be displayed in a scrolling list and on a map <a href="https://www.figma.com/file/74Xvu3tfj3sJva6NfTtIg4/Friend-List-Task ">(as per the design reference)</a>.<br>
• Tapping on a user in the list, or annotation in the map view, should display the user details in a panel.<br>
• Tapping on a number view (bottom right corner) should bring the text field up to where you can enter a random number which will then be used for fetching users from the API.<br>
• The task is to be completed using Swift, UIKit, and MapBox, you have all of the freedom to use (or not to) any 3rd party libraries.<br>
Most importantly, surprise us! We’d love to see how you bring a simple feature like this to life with interactions.

## Random User API
<a href="https://randomuser.me/">Random User API</a> it's a free, open-source API for generating random user data. Like Lorem Ipsum, but for people. It generates many different properties and values for a user.

Below is a sample of the data that you can get from the API (For more please check website documentation).
```
{
  "results": [
    {
      "gender": "male",
      "name": {
        "title": "mr",
        "first": "brad",
        "last": "gibson"
      },
      "location": {
        "street": "9278 new road",
        "city": "kilcoole",
        "state": "waterford",
        "postcode": "93027",
        "coordinates": {
          "latitude": "20.9267",
          "longitude": "-7.9310"
        },
        "timezone": {
          "offset": "-3:30",
          "description": "Newfoundland"
        }
      },
      "email": "brad.gibson@example.com",
      "login": {
        "uuid": "155e77ee-ba6d-486f-95ce-0e0c0fb4b919",
        "username": "silverswan131",
        "password": "firewall",
        "salt": "TQA1Gz7x",
        "md5": "dc523cb313b63dfe5be2140b0c05b3bc",
        "sha1": "7a4aa07d1bedcc6bcf4b7f8856643492c191540d",
        "sha256": "74364e96174afa7d17ee52dd2c9c7a4651fe1254f471a78bda0190135dcd3480"
      },
      "dob": {
        "date": "1993-07-20T09:44:18.674Z",
        "age": 26
      },
      "registered": {
        "date": "2002-05-21T10:59:49.966Z",
        "age": 17
      },
      "phone": "011-962-7516",
      "cell": "081-454-0666",
      "id": {
        "name": "PPS",
        "value": "0390511T"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/75.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
      },
      "nat": "IE"
    }
  ],
  "info": {
    "seed": "fea8be3e64777240",
    "results": 1,
    "page": 1,
    "version": "1.3"
  }
}
```
## Work Process
How I started working?
Firstly, I analized the API. What kind of data it offers? How it works? and more.
Then, based on the UI design I received, I analized what kind of data I need for the user. After realizing which data are needed and which ones are not, I visualized them using `UML Diagrams`. 

<img src="right-arrow.svg">

Thanks to the structure of the JSON API, I could easily achieve High Cohesion on my project. Which is really important for reducing module complexity and software maintainance.


## Architecture
## Conclusion
