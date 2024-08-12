module "app"{ }
module " db"{}

module "lb" {
    instances = [
        module.app.self_link
        module.db.self_link
    ]
}