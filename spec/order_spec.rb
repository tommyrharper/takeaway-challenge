require 'order'

describe Order do

  let(:menu_double) { double :Menu, list: { :fish => "£5", :chips => "£3", :salad => "£2" } }
  let(:order_double) { double :order, confirm: "Thank you! Your order was placed and will be delivered before #{Time.new + Order::DELIVERY_TIME}" }

  it 'returns the menu on #menu' do
    order = Order.new(menu_double)
    expect(order.menu).to include(
      :fish => "£5",
      :chips => "£3",
      :salad => "£2"
    )
  end

  it 'allows the user to #add to their order' do
    order = Order.new(menu_double)
    expect(order.update("1 fish, 3 salad, 2 chips")).to include(:fish => 1, :salad => 3, :chips => 2)
  end

  it '#cost returns total order cost' do
    order = Order.new(menu_double)
    order.update("1 fish, 3 salad, 2 chips")
    expect(order.cost).to eq 17
  end

  it 'allows user to confirm order' do
    order = Order.new(menu_double)
    order.update("1 fish, 3 salad, 2 chips")
    expect(order_double.confirm).to include("Thank you! Your order was placed and will be delivered before #{Time.new + Order::DELIVERY_TIME}")
  end

  it 'throws an error if the order is not on the list' do
    order = Order.new(menu_double)
    expect { order.update("1 cat") }.to raise_error 'cat is not on the menu'
  end

  it 'throws an error if the order number is negative' do
    order = Order.new(menu_double)
    expect { order.update("-3 fish") }.to raise_error 'cannot order a negative number'
  end

  it 'allows the user to change order' do
    order = Order.new(menu_double)
    order.update("1 fish, 3 salad, 2 chips")
    expect(order.update("2 fish, 0 salad, 2 chips")).to include(:fish => 2, :chips => 2)
  end

  it 'allows the user to remove an item' do
    order = Order.new(menu_double)
    order.update("1 fish, 3 salad, 2 chips")
    expect(order.update("2 fish, 0 salad, 2 chips")).to_not include(:salad)
  end
  
end
