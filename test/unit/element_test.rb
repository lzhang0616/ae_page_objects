require 'unit_helper'

module AePageObjects
  class ElementTest < ActiveSupport::TestCase
  
    def test_new__no_name_no_locator
      pet_class   = ::AePageObjects::Document.new_subclass
      kitty_class = ::AePageObjects::Element.new_subclass

      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      pet           = pet_class.new
      
      error = assert_raises ArgumentError do
        kitty_class.new(pet)
      end

      assert_include error.message, ":name or :locator is required"
    end
    
    def test_new
      pet_class   = ::AePageObjects::Document.new_subclass
      kitty_class = ::AePageObjects::Element.new_subclass

      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      pet           = pet_class.new

      kitty_page_object = mock
      capybara_stub.session.expects(:find).with("#tiger").returns(kitty_page_object)
      kitty = kitty_class.new(pet, :locator => '#tiger')

      assert_equal pet, kitty.parent
      assert_equal kitty_page_object, kitty.node
      assert_equal nil, kitty.full_name
      assert_equal nil, kitty.name
      assert_false kitty.using_default_locator?
    end

    def test_new__with_name
      pet_class   = ::AePageObjects::Document.new_subclass
      kitty_class = ::AePageObjects::Element.new_subclass

      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      pet           = pet_class.new

      kitty_page_object = mock
      capybara_stub.session.expects(:find).with("#tiger").returns(kitty_page_object)
      kitty = kitty_class.new(pet, :name => 'tiger')

      assert_equal pet, kitty.parent
      assert_equal kitty_page_object, kitty.node
      assert_equal "tiger", kitty.full_name
      assert_equal "tiger", kitty.name
      assert kitty.using_default_locator?
    end

    def test_new__locator
      pet_class   = ::AePageObjects::Document.new_subclass
      kitty_class = ::AePageObjects::Element.new_subclass

      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      pet           = pet_class.new
      
      kitty_page_object = mock
      capybara_stub.session.expects(:find).with("J 2da K").returns(kitty_page_object)
      kitty = kitty_class.new(pet, :name => 'tiger', :locator => "J 2da K")
      
      assert_equal pet, kitty.parent
      assert_equal kitty_page_object, kitty.node
      assert_equal "tiger", kitty.full_name
      assert_equal "tiger", kitty.name
      assert_false kitty.using_default_locator?
    end
    
    def test_document
      kitty_page_class = ::AePageObjects::Document.new_subclass
      kitty_class      = ::AePageObjects::Element.new_subclass

      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      kitty_page    = kitty_page_class.new
      assert_equal kitty_page, kitty_page.document

      capybara_stub.session.stubs(:find).returns(capybara_stub.session)
      
      kitty1 = kitty_class.new(kitty_page, :name => 'tiger')
      kitty2 = kitty_class.new(kitty1,     :name => 'tiger')
      kitty3 = kitty_class.new(kitty2,     :name => 'tiger')
      
      assert_equal kitty_page, kitty1.parent
      assert_equal kitty1, kitty2.parent
      assert_equal kitty2, kitty3.parent

      assert_equal kitty_page, kitty1.document
      assert_equal kitty_page, kitty2.document
      assert_equal kitty_page, kitty3.document
    end
  end
end