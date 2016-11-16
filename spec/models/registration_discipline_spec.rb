require 'spec_helper'

RSpec.describe RegistrationDiscipline, type: :model do
  describe "#abbrev_and_members" do
    describe "for an individual discipline" do
      before(:each) do
        @event = FactoryGirl.create :event
        @discipline = FactoryGirl.create :discipline, name: "Masters Individual Ballet", abbreviation: "MIB", id: 1
        @event_discipline = FactoryGirl.create :event_discipline, event: @event, discipline: @discipline
        @event_registration = FactoryGirl.create :event_registration, event: @event
        @registration_discipline = RegistrationDiscipline.create(event_discipline: @event_discipline, event_registration: @event_registration)
      end

      it "should display the abbreviation only" do
        expect(@registration_discipline.abbrev_and_members).to eq "MIB"
      end
    end

    describe "for a pair/team discipline" do    
      before(:each) do
        @event = FactoryGirl.create :event
        @discipline = FactoryGirl.create :discipline, name: "Masters Team Ballet", abbreviation: "MTB", id: 13
        @event_discipline = FactoryGirl.create :event_discipline, event: @event, discipline: @discipline
        @event_registration = FactoryGirl.create :event_registration, event: @event
        @registration_discipline = RegistrationDiscipline.create(event_discipline: @event_discipline, event_registration: @event_registration, group_name: "El Commish!", group_members: "Jared Haworth, Jack Wilson")
      end

      it "should display the abbreviation only" do
        expect(@registration_discipline.abbrev_and_members).to eq "MTB El Commish! (Jared Haworth, Jack Wilson)"
      end
    end
  end
end
