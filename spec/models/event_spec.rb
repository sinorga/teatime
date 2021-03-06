require 'rails_helper'

RSpec.describe Event, :type => :model do
  it { should belong_to(:shop) }
  it { should belong_to(:owner).class_name('User') }
  it { should have_many(:orders) }

  describe "#active?" do
    it "returns ture when the end time dose not be reached" do
      event = Fabricate.build(:event, end_time: 1.day.from_now)
      expect(event.active?).to be_truthy
    end
    it "returns false when reached the end time" do
      event = Fabricate.build(:event, end_time: 1.day.ago)
      expect(event.active?).to be_falsey
    end
  end

  describe "default_scope order" do
    it "always sort by end_time DESC" do
      event1 = Fabricate(:event, end_time: 2.days.from_now)
      event2 = Fabricate(:event, end_time: 3.days.from_now)
      event3 = Fabricate(:event, end_time: 1.day.from_now)

      expect(Event.all).to eq([event2, event1, event3])
    end
  end

  describe "#shop_name" do
    it "returns shop name of event" do
      event = Fabricate(:event)
      expect(event.shop_name).to eq(event.shop.name)
    end
  end

  describe "#shop_beverages" do
    it "returns shop's beverages of event" do
      event = Fabricate(:event)
      expect(event.shop_beverages).to match_array(event.shop.beverages)
    end
  end

  describe "validate end time" do
    it "can not be in the past" do
      Event.create(shop_id:1, end_time: 1.day.ago)
      expect(Event.count).to eq(0)
    end
  end
end
