    workspace "I'll Have the BLT" "Система онлайн-заказов сети Кафе-сендвичной" {

    model {

        customer = person "Клиент" "Просматривает меню и оформляет заказы."
        kitchenStaff = person "Сотрудник кухни" "Получает и готовит заказы."
        driver = person "Курьер" "Получает задания на доставку."
        franchiseManager = person "Менеджер франшизы" "Управляет магазином и локальными акциями."
        corporateEmployee = person "Сотрудник головной компании" "Управляет сетью и национальными акциями."

        paymentProvider = softwareSystem "Платежная система" "Проводит онлайн-платежи."
        mapProviderPrimary = softwareSystem "Картографический сервис A" "Предоставляет маршруты и дорожную информацию."
        mapProviderSecondary = softwareSystem "Картографический сервис B" "Резервный поставщик маршрутов и дорожной информации."


        blt = softwareSystem "BLT Online Ordering System" "Система онлайн-заказов сети сэндвич-магазинов." {

            // UI

            customerWeb = container "Веб-приложение клиента" "Просмотр меню и оформление заказов." "Web"
            customerMobile = container "Мобильное приложение клиента" "Просмотр меню и оформление заказов." "Mobile"
            kitchenApp = container "Приложение кухни" "Работа кухни с заказами." "Web"
            driverApp = container "Приложение курьера" "Работа с доставками." "Mobile"
            adminApp = container "Административное приложение" "Управление магазинами, меню и акциями." "Web"


            // Gateway

            gateway = container "API Gateway" "Единая точка входа." "API Gateway"


            // Services

            store = container "Сервис магазинов" "Управляет магазинами, адресами, графиком работы и доступностью доставки." "Микросервис"
            catalog = container "Сервис каталога" "Управляет меню, товарами и ценами." "Микросервис"
            promotion = container "Сервис акций" "Управляет национальными и локальными акциями." "Микросервис"
            order = container "Сервис заказов" "Управляет жизненным циклом заказов." "Микросервис"
            fulfillment = container "Сервис приготовления" "Управляет приготовлением заказов." "Микросервис"
            payment = container "Сервис платежей" "Управляет онлайн-платежами." "Микросервис"
            delivery = container "Сервис доставки" "Управляет доставкой заказов." "Микросервис"
            routing = container "Сервис маршрутизации" "Строит маршруты через внешние картографические сервисы." "Микросервис"
            broker = container "Брокер сообщений" "Передает бизнес-события." "Kafka"


            // Databases

            storeDb = container "БД магазинов" "Хранит информацию о магазинах." "PostgreSQL" {
                tags "Database"
            }

            catalogDb = container "БД каталога" "Хранит меню, товары и цены." "PostgreSQL" {
                tags "Database"
            }

            promotionDb = container "БД акций" "Хранит национальные и локальные акции." "PostgreSQL" {
                tags "Database"
            }

            orderDb = container "БД заказов" "Хранит заказы." "PostgreSQL" {
                tags "Database"
            }

            fulfillmentDb = container "БД приготовления" "Хранит состояние приготовления." "PostgreSQL" {
                tags "Database"
            }

            paymentDb = container "БД платежей" "Хранит платежи." "PostgreSQL" {
                tags "Database"
            }

            deliveryDb = container "БД доставки" "Хранит доставки." "PostgreSQL" {
                tags "Database"
            }
        }


        customer -> customerWeb "Использует"
        customer -> customerMobile "Использует"
        kitchenStaff -> kitchenApp "Использует"
        driver -> driverApp "Использует"
        franchiseManager -> adminApp "Управляет магазином и локальными акциями"
        corporateEmployee -> adminApp "Управляет сетью и национальными акциями"


        customerWeb -> gateway "API-запросы" "HTTPS"
        customerMobile -> gateway "API-запросы" "HTTPS"
        kitchenApp -> gateway "API-запросы" "HTTPS"
        driverApp -> gateway "API-запросы" "HTTPS"
        adminApp -> gateway "API-запросы" "HTTPS"


        gateway -> store "Работает с магазинами" "REST"
        gateway -> catalog "Получает меню и товары" "REST"
        gateway -> promotion "Работает с акциями" "REST"
        gateway -> order "Работает с заказами" "REST"
        gateway -> fulfillment "Работает с приготовлением" "REST"
        gateway -> delivery "Работает с доставками" "REST"
        gateway -> routing "Запрашивает маршруты" "REST"


        order -> store "Проверяет магазин и доступность доставки" "REST"
        order -> catalog "Получает товары и цены" "REST"
        order -> promotion "Рассчитывает скидки" "REST"
        order -> fulfillment "Получает оценочное время приготовления" "REST"
        order -> payment "Инициирует оплату" "REST"


        payment -> paymentProvider "Проводит платеж" "HTTPS"


        delivery -> routing "Запрашивает маршрут доставки" "REST"
        routing -> mapProviderPrimary "Получает маршрут и дорожную ситуацию" "HTTPS"
        routing -> mapProviderSecondary "Получает альтернативный маршрут" "HTTPS"


        store -> storeDb
        catalog -> catalogDb
        promotion -> promotionDb
        order -> orderDb
        fulfillment -> fulfillmentDb
        payment -> paymentDb
        delivery -> deliveryDb


        order -> broker "Публикует события заказов" "Kafka"
        payment -> broker "Публикует события платежей" "Kafka"
        fulfillment -> broker "Публикует события приготовления" "Kafka"
        delivery -> broker "Публикует события доставки" "Kafka"
        broker -> order "Передает события платежей и доставки" "Kafka"
        broker -> fulfillment "Передает события заказов" "Kafka"
        broker -> delivery "Передает события заказов и приготовления" "Kafka"
    }



    views {

        systemContext blt "SystemContext" {
            include *
        }


        container blt "Containers" {
            include *
        }



        dynamic blt "OrderFlow" {

            title "Оформление заказа"

            customer -> customerWeb "Оформляет заказ"
            customerWeb -> gateway "Отправляет заказ"
            gateway -> order "Создает заказ"
            order -> store "Проверяет магазин"
            order -> catalog "Получает товары и цены"
            order -> promotion "Рассчитывает скидки"
            order -> fulfillment "Получает оценочное время приготовления"
            order -> payment "Инициирует оплату"
            payment -> paymentProvider "Выполняет платеж"
            payment -> broker "Публикует событие об оплате"
            broker -> order "Передает событие об оплате"
            order -> broker "Публикует событие о созданном заказе"
            broker -> fulfillment "Передает заказ на приготовление"

        }


        dynamic blt "PickupFlow" {

            title "Маршрут клиента до магазина"
            customer -> customerMobile "Открывает заказ"
            customerMobile -> gateway "Запрашивает маршрут до магазина"
            gateway -> routing "Запрашивает маршрут"
            routing -> mapProviderPrimary "Получает маршрут с учетом дорожной ситуации"

        }


        dynamic blt "DeliveryFlow" {

            title "Приготовление и доставка"

            kitchenStaff -> kitchenApp "Отмечает заказ готовым"
            kitchenApp -> gateway "Отправляет новый статус"
            gateway -> fulfillment "Обновляет статус приготовления"
            fulfillment -> broker "Публикует событие о готовности"
            broker -> delivery "Передает событие о готовности"
            driver -> driverApp "Открывает список доставок"
            driverApp -> gateway "Запрашивает доставки"
            gateway -> delivery "Получает доставки курьера"
            delivery -> routing "Запрашивает маршрут"
            routing -> mapProviderPrimary "Получает маршрут"
            delivery -> broker "Публикует статус доставки"
            broker -> order "Передает статус доставки"

        }


        styles {

            element "Person" {
                shape person
            }

            element "Database" {
                shape cylinder
            }
        }
    }
}