require File.dirname(__FILE__) + '/../spec_helper'

describe RubyWarrior::Profile do
  before(:each) do
    @profile = RubyWarrior::Profile.new('path/to/tower', 'Warrior')
  end
  
  it "should have warrior name" do
    @profile.warrior_name.should == 'Warrior'
  end
  
  it "should load tower from path" do
    RubyWarrior::Tower.expects(:new).with('path/to/tower').returns('tower')
    @profile.tower.should == 'tower'
  end
  
  it "should start level number at 0" do
    @profile.level_number.should be_zero
  end
  
  it "should start score at 0 and allow it to increment" do
    @profile.score.should be_zero
    @profile.score += 5
    @profile.score.should == 5
  end
  
  it "should have no abilities and allow adding" do
    @profile.abilities.should == []
    @profile.abilities += [:foo, :bar]
    @profile.abilities.should == [:foo, :bar]
  end
  
  it "should encode with marshal + base64" do
    @profile.encode.should == Base64.encode64(Marshal.dump(@profile))
  end
  
  it "should decode with marshal + base64" do
    RubyWarrior::Profile.decode(@profile.encode).warrior_name.should == @profile.warrior_name
  end
  
  it "load should read file and decode" do
    File.expects(:read).with('path/to/.profile').returns('encoded_profile')
    RubyWarrior::Profile.expects(:decode).with('encoded_profile').returns('profile')
    RubyWarrior::Profile.load('path/to/.profile').should == 'profile'
  end
  
  it "save should write file with encoded profile" do
    file = stub
    file.expects(:write).with('encoded_profile')
    File.expects(:open).with(@profile.player_path + '/.profile', 'w').yields(file)
    @profile.expects(:encode).returns('encoded_profile')
    @profile.save
  end
  
  it "should have a nice string representation" do
    @profile.to_s.should == "Warrior - tower - level 0 - score 0"
  end
  
  it "should guess at the player path" do
    @profile.player_path.should == 'ruby-warrior/tower-tower'
  end
  
  it "should add abilities and remove duplicates" do
    @profile.add_abilities(:foo, :bar, :blah, :bar)
    @profile.abilities.should == [:foo, :bar, :blah]
  end
  
  describe "with tower" do
    before(:each) do
      @tower = RubyWarrior::Tower.new('foo')
      @profile.stubs(:tower).returns(@tower)
    end
    
    it "should return nil if current level is zero" do
      @tower.expects(:build_level).never
      @profile.current_level.should be_nil
    end
    
    it "should fetch current level from tower" do
      @profile.level_number = 1
      @tower.expects(:build_level).with(1, @profile)
      @profile.current_level
    end
  
    it "should fetch next level" do
      @tower.expects(:build_level).with(1, @profile)
      @profile.next_level
    end
  end
end
