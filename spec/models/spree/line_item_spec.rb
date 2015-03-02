require 'spec_helper'

describe Spree::LineItem do
  it {should have_one :subscription}
end
