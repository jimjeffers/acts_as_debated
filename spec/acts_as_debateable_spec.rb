require File.dirname(__FILE__) + '/spec_helper'

describe "ActsAsDebated" do
  before(:each) do
    # For specs to work assume a model named Answer has acts_as_debateable mixin.
    @model = Answer.create!({:user_id => 10, :question_id => 1, :contents => 'Test'})
    @user = User.create!({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' })
    @user2 = User.create!({ :login => 'quire2', :email => 'quire2@example.com', :password => 'quire69', :password_confirmation => 'quire69' })
  end
  
  describe "debate_it" do
    it "should not create more than one rating for the same object from the same user" do
      @model.debate_it(true,@user)
      @model.debate_it(false,@user)
      @model.debateables.length.should equal(1)
    end
  end
  
  describe "thumbs_up/down_from" do
    it "should return a score of -1 if only one thumbsdown submitted" do
      @model.thumbs_down_from(@user)
      @model.debated_score.should equal(-1)
    end

    it "should return a score of 1 if only one thumbsup submitted" do
      @model.thumbs_up_from(@user)
      @model.debated_score.should equal(1)
    end

    it "should return a score of -1 if a single user reverses his/her decision" do
      @model.thumbs_up_from(@user)
      @model.thumbs_down_from(@user)
      @model.debated_score.should equal(-1)
    end

    it "should return a score of 1 if a single user reverses his/her decision" do
      @model.thumbs_down_from(@user)
      @model.thumbs_up_from(@user)
      @model.debated_score.should equal(1)
    end

    it "should return a score of 1 if a single user gives two thumbs up" do
      @model.thumbs_up_from(@user)
      @model.thumbs_up_from(@user)
      @model.debated_score.should equal(1)
    end

    it "should return a score of -1 if a single user gives two thumbs down" do
      @model.thumbs_down_from(@user)
      @model.thumbs_down_from(@user)
      @model.debated_score.should equal(-1)
    end

    it "should return a score of 2 if a two users give two thumbs up" do
      @model.thumbs_up_from(@user)
      @model.thumbs_up_from(@user2)
      @model.debated_score.should equal(2)
    end

    it "should return a score of -2 if a two users give two thumbs down" do
      @model.thumbs_down_from(@user)
      @model.thumbs_down_from(@user2)
      @model.debated_score.should equal(-2)
    end

    it "should return a score of 0 if a two users give two opposing votes" do
      @model.thumbs_up_from(@user)
      @model.thumbs_down_from(@user2)
      @model.debated_score.should equal(0)
    end
  end
  
  describe "debated_by?" do
    it "should return false if the user has not submitted a debateable" do
      @model.debated_by?(@user).should be(false)
    end
    
    it "should return true if the user has submitted a debateable" do
      @model.thumbs_down_from(@user)
      @model.debated_by?(@user).should be(true)
    end
  end
  
end