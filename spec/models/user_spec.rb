require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'associations' do
    it 'has many subscriptions' do
      should have_many(:subscriptions)
    end

    it 'has many syndications' do
      should have_many(:syndications)
    end

    it 'has many subscription_lists through subscriptions' do
      should have_many(:subscription_lists).through(:subscriptions)
    end
  end

  describe 'validations' do
    it 'validates presence of first_name' do
      should validate_presence_of(:first_name)
    end

    it 'validates presence of last_name' do
      should validate_presence_of(:last_name)
    end

    it 'validates presence of email_confirmation_code' do
      should validate_presence_of(:email_confirmation_code)
    end

    it 'validates presence of email_address' do
      should validate_presence_of(:email_address)
    end

    it 'validates uniqueness of email_address' do
      should validate_uniqueness_of(:email_address).case_insensitive
    end

    it 'validates UUID format' do
      should allow_values(
        '63663ebc-db0b-4866-ab0d-5cf8714a6143',
        '994f76d1-b767-46b2-af64-2e2a47a12f73'
      ).for(:uuid)

      should_not allow_values(
        '63663ebc-db0b-4866-ab0d-5cf8714a614',
        '63663ebc-db0b-4866-ab0d-5cf8714a614cz',
      ).for(:uuid)
    end

    it 'validates email format' do
      should allow_values(
        'test@example.com',
        'test.two+1@example.co.uk',
      ).for(:email_address)

      should_not allow_values(
        'test @example.com',
        'test.two+1aexample.co.uk',
      ).for(:email_address)
    end
  end

  describe 'before_save' do
    subject { build(:user, email_address: 'UPPERCASE@example.com') }

    it 'dowcases email address before save' do
      subject.save
      expect(subject.email_address).to eq('uppercase@example.com')
    end
  end

  describe 'helper_functions' do
    describe 'name' do
      it 'returns a concatenation of first and last name' do
        expect(subject.name).to eq("#{subject.first_name} #{subject.last_name}")
      end
    end

    describe 'downcase_email_address' do
      it 'returns the downcased email addres' do
        subject.email_address = 'ABC@example.com'
        expect(subject.downcase_email_address).to eq('abc@example.com')
      end
    end
  end
end
