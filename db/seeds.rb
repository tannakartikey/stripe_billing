# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

plans = [
  {
    name: '10 Monthly',
    stripe_id: '10-monthly',
    price: 10
  },
  {
    name: '10 Yearly',
    stripe_id: '10-yearly',
    price: 102
  },
  {
    name: '25 Monthly',
    stripe_id: '25-monthly',
    price: 25
  },
  {
    name: '25 Yearly',
    stripe_id: '25-yearly',
    price: 255
  },
  {
    name: 'Free',
    stripe_id: nil,
    price: 0
  }
]
def interval(id)
  id.match(/monthly/) ? "month" : "year"
end
plans.each do |plan|
  Plan.find_or_create_by(plan)
  begin
    Stripe::Plan.retrieve(plan[:stripe_id]) unless plan[:name] == "Free"
  rescue Stripe::InvalidRequestError => error
    if error.message.gsub(/No such plan/)
      puts "plan #{plan[:name]} does not exist on Stripe. Creating it..."
      Stripe::Plan.create(
        amount: plan[:price] * 100,
        interval: interval(plan[:stripe_id]),
        name: plan[:name],
        id: plan[:stripe_id],
        currency: "usd"
      )
      puts "plan #{plan[:name]} created on Stripe account!"
    else
      raise
    end
  end
end

