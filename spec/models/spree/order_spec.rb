require 'spec_helper'

describe Spree::Order do
  it { should belong_to :subscription }
end
