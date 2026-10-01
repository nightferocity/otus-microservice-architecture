# Синхронное взаимодействие. REST

| Откуда | Куда | Назначение | Пример контракта |
|---|---|---|---|
| API Gateway | Store Service | Получение магазинов | `GET /stores` |
| API Gateway | Store Service | Получение конкретного магазина | `GET /stores/{storeId}` |
| Order Service | Store Service | Проверка магазина | `GET /stores/{storeId}` |
| Order Service | Store Service | Проверка доставки | `GET /stores/{storeId}/delivery-availability` |
| API Gateway | Catalog Service | Получение меню | `GET /stores/{storeId}/menu` |
| Order Service | Catalog Service | Проверка товаров и цен | `POST /catalog/items/validate` |
| API Gateway | Promotion Service | Получение доступных акций | `GET /promotions` |
| Order Service | Promotion Service | Расчет скидок | `POST /promotions/calculate` |
| API Gateway | Order Service | Создание заказа | `POST /orders` |
| API Gateway | Order Service | Получение заказа | `GET /orders/{orderId}` |
| Order Service | Fulfillment Service | Получение оценки времени приготовления | `POST /fulfillment/estimate` |
| Order Service | Payment Service | Инициация платежа | `POST /payments` |
| API Gateway | Delivery Service | Получение доставок курьера | `GET /drivers/{driverId}/deliveries` |
| Delivery Service | Routing Service | Расчет маршрута | `POST /routes` |
| API Gateway | Routing Service | Маршрут клиента до магазина | `POST /routes` |
| Routing Service | Map Provider | Получение маршрута | API внешнего провайдера |