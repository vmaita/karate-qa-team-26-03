Feature:  Flujo Auth

  @token
  Scenario:  CP01 - Crear Token - OK
    Given url 'https://restful-booker.herokuapp.com'
    And path '/auth'
    And request { username : "admin", password : "password123" }
    When method post
    Then status 200
    And response.token == '#string'
    * def token = response.token

  Scenario Outline:  CP01 -<nombre>  - NOK
    Given url 'https://restful-booker.herokuapp.com'
    And path '/auth'
    And request { "username" : <username>, password : <password>}
    When method post
    Then status 200
    And match response.reason == "Bad credentials"

    Examples:
    |username| password   |nombre|
    |admin   | password800| Contrasena incorrecta|
    |carlos  | password123| Usuario incorecto    |

  Scenario:  CP03 - Ejemplo 2
    Given url 'https://restful-booker.herokuapp.com'
    And path '/booking'
    And params { firstname : "sally", lastname : "brown" }
    When method get
    Then status 200

  Scenario Outline: CP03.1 - Ejemplo 2
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking'
    And param firstname = '<firstname>'
    And param lastname = '<lastname>'
    When method GET
    Then status 200

    Examples:
      | firstname | lastname |
      | sally     | brown    |

  Scenario: CP05 - GetbookingId - OK
    * def id = 92
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/' + id
    When method get
    Then status 200
    And match response.firstname == '#string'
    And match response.lastname == '#string'
    And match response.totalprice == '#number'

  Scenario: CP06 - Update Booking
    Given url 'https://restful-booker.herokuapp.com'
    And path '/booking/1'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=2d68f97097bc51c'
    And request
    """
    {
        "firstname" : "James",
        "lastname" : "Brown",
        "totalprice" : 111,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method put
    Then status 200
    And match response.firstname == 'James'
    And match response.lastname == 'Brown'

  Scenario:  CP07 - CreateBooking
    * def bodybooking = read ('booking.json')
    Given url 'https://restful-booker.herokuapp.com'
    And path '/booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request bodybooking
    When method post
    Then status 200

  Scenario: CP06 - Update Booking Mejorado
    Given url 'https://restful-booker.herokuapp.com'
    And path '/auth'
    And request { username : "admin", password : "password123" }
    When method post
    Then status 200
    * def tokenAuth = response.token
    * print tokenAuth
    Given url 'https://restful-booker.herokuapp.com'
    And path '/booking/1'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=' +tokenAuth
    And request
    """
    {
        "firstname" : "James",
        "lastname" : "Brown",
        "totalprice" : 111,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method put
    Then status 200


    Scenario:  CP08 -Update booking con call
      * def responseToken = call read ('classpath:examples/booking/auth.feature@token')
      * print responseToken
      * def tokenAuth = responseToken.token

      Given url 'https://restful-booker.herokuapp.com'
      And path '/booking/1'
      And header Content-Type = 'application/json'
      And header Accept = 'application/json'
      And header Cookie = 'token=' +tokenAuth
      And request
    """
    {
        "firstname" : "James",
        "lastname" : "Brown",
        "totalprice" : 111,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
      When method put
      Then status 200


