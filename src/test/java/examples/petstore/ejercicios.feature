Feature: Ejercicios Basicos

  # Background:
  #  Given url 'https://petstore.swagger.io/v2'

  Scenario: CP01 - Login exitoso
    Given url 'https://petstore.swagger.io/v2'
    And path '/user/login'
    And param username = 'admin'
    And param password = '123456'
    When method get
    Then status 200

  Scenario: CP02 - Crear registro
    Given url 'https://petstore.swagger.io/v2'
    And path '/store/order'
    And request
    """
    {
      "id": 0,
      "petId": 0,
      "quantity": 0,
      "shipDate": "2026-02-25T02:03:54.137Z",
      "status": "placed",
      "complete": true
    }
    """
    When method post
    Then status 200

  Scenario: CP03 - Update Pet
    Given url 'https://petstore.swagger.io/v2'
    And path '/pet'
    And request
    """
    {
      "id": 0,
      "category": {
        "id": 0,
        "name": "Loki"
      },
      "name": "doggie",
      "photoUrls": [
        "Bubu"
      ],
      "tags": [
        {
          "id": 0,
          "name": "MACHIN"
        }
      ],
      "status": "available"
    }
    """
    When method post
    Then status 200

  Scenario: CP04-  Crear registro con variables
    * def bodyOrder =
    """
    {
      "id": 0,
      "petId": 0,
      "quantity": 0,
      "shipDate": "2026-02-25T02:03:54.137Z",
      "status": "placed",
      "complete": true
    }
    """
    Given url 'https://petstore.swagger.io/v2'
    And path '/store/order'
    * print bodyOrder
    And request bodyOrder
    When method post
    * print response
    * print 'Hola esta es una prueba: {}', response
    Then status 200

  Scenario: Prueba de assert
    # tipo de dato string
    * def color = 'red '

    # tipo de dato número
    * def num = 5

    # 1+1=2, '11'
    # '1' + '1' = '11'

    # suma 'red' + 5 = red 5
    Then assert color + num =='red 5'

  Scenario: CP04 - Actualizar información de mascota
    Given url "https://petstore.swagger.io/v2"
    And path '/pet'
    And request
    """
    {
      "id": 3,
      "category": {
        "id": 0,
        "name": "dog"
      },
      "name": "doggie",
      "photoUrls": [
        "string"
      ],
      "tags": [
        {
          "id": 0,
          "name": "string"
        }
      ],
      "status": "available"
    }
    """
    When method put
    Then status 200
    And match response.category.name == 'dog'
    And match response.status == 'available'

  Scenario: caso de prueba - Crear Orden
    Given url "https://petstore.swagger.io/v2"
    And path '/store/order'
    And request
    """
    {
      "id": 0,
      "petId": 0,
      "quantity": 0,
      "shipDate": "2026-02-25T02:03:54.137Z",
      "status": "placed",
      "complete": true
    }
    """
    When method post
    Then status 200
    And match response.status == 'placed'
    And match response.complete == true

  Scenario: CP05 - Bucar mascota por estado
    Given url "https://petstore.swagger.io/v2"
    And path '/pet/findByStatus'
    And param status = 'sold'
    When method get
    Then status 200
    * print response
    # Recorrido de la lista de mascotas que su id sea de tipo numero
    # And match response[223].id == '#number'
    # And match response[223].name == '#string'
    And match each response[*].id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == 'sold'

  Scenario: CP06 - Bucar mascota por estado con mejora de variables
    * def filter = 'sold'
    Given url "https://petstore.swagger.io/v2"
    And path '/pet/findByStatus'
    And param status = filter
    When method get
    Then status 200
    * print response
    # Recorrido de la lista de mascotas que su id sea de tipo numero
    # And match response[223].id == '#number'
    # And match response[223].name == '#string'
    And match each response[*].id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == filter














