Feature: Request and Response

  Scenario: CP01 - Actualizar mascota
    Given url 'https://petstore.swagger.io/v2'
    And path '/pet'
    And request read('bodyPet.json')
    When method put
    Then status 200
    And match $.id == 3

  Scenario: CP02 - Actualizar mascota v2
    * def bodyPet = read('bodyPet.json')
    Given url 'https://petstore.swagger.io/v2'
    And path '/pet'
    And request bodyPet
    When method put
    Then status 200
  * print bodyPet
    And match $.id == bodyPet.id
    And match $ == bodyPet

  Scenario: CP03 - Crear Token
    Given url 'https://restful-booker.herokuapp.com'
    And path '/auth'
    And header Content-Type = 'application/json'
    And request { username : 'admin', password : 'password123' }
    When method post
    Then status 200
    And match $.token == '#string'
    And match responseType == 'json'

  Scenario: CP04 - Actualizar mascota con ID
    * def paramPet = read('parameterPet.json')
    Given url 'https://petstore.swagger.io/v2'
    And path '/pet/' + paramPet.id
    And form field name = paramPet.name
    And form field status = paramPet.status
    When method post
    Then status 200
    And match $.message == paramPet.id






