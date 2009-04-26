require File.dirname(__FILE__) + '/spec_helper'

describe "ActsAsDebateable" do
  it "should destroy the universe" do
    answer = Answer.new
    answer.should be_an(Answer)
  end
end