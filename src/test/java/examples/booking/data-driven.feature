Feature: Casos dinamicos

  Background:
    * def responseToken = call read('classpath:examples/booking/auth.feature@token-parameter') {user: 'admin', pass:'password123'}
    * print responseToken
    * def authtoken = 'token=' + responseToken.token
    Given  url 'https://restful-booker.herokuapp.com'

  Scenario: CP01 - Partial Update Booking
    * def id = 1

    And path 'booking/' +id
    And headers {Content-Type: "application/json", Accept: "application/json", Cookie: #(authtoken)}
    And request {'firstname': "James", 'lastname' : "Brown"}'
    When method patch
    Then status 200
    # falta validaciones

  Scenario Outline: CP02 - Data dinamica CSV
    And path 'booking'
    And request
    """
    {
        "firstname" : <firstname>,
        "lastname" : <lastname>,
        "totalprice" : <totalprice>,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method post
    Then status 418

    Examples:
      |read('data.csv')|


  Scenario Outline: CP03 - UpdateBooking
    * def id = 1
    And path 'booking/' +id
    And headers {Content-Type: "application/json", Accept: "application/json", Cookie: #(authtoken)}
    And request
    """
    {
        "firstname" : <firstname>,
        "lastname" : <lastname>,
        "totalprice" : <totalprice>,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method PUT
    Then status 200

    Examples:
      |read('data.csv')|

    Scenario: CP04 - DeleteBooking
      * def id = 1091
      And path 'booking/' +id
      And headers {Content-Type: "application/json", Cookie: #(authtoken)}
      When method delete
      Then status 201 || status 204

      Scenario Outline: CP05 - Booking - CreateBooking
        And path 'booking'
        And headers {Content-Type: "application/json", Accept: "application/json",Cookie: #(authtoken)}
        And request
        """
        {
            "firstname" : "<firstname>",
            "lastname" : "<lastname>",
            "totalprice" : <totalprice>,
            "depositpaid" : true,
            "bookingdates" : {
                "checkin" : "2018-01-01",
                "checkout" : "2019-01-01"
            },
            "additionalneeds" : "Breakfast"
        }
        """
        When method post
        Then status 200
        And match response.bookingid == '#number'
        And match response.booking.firstname == "<firstname>"
        And match response.booking.lastname == "<lastname>"
        * def bookingId = response.bookingid
        * print 'Booking creado:', bookingId

        Examples:
          |read('data.csv')|
        
    Scenario Outline: CP-03- Data dinamica CSV
      And path 'booking'
      And request read ('data-driven.json')
      When method post
      Then status 418

      Examples:
      |firstname| lastname| totalprice| depositpaid|
      |carlos   |zambrano |1234       |true        |
      |jose     |perez    |2345       |true        |
      |pepe     |suarez   |34567      |true        |


