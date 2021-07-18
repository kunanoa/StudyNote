require 'test_helper'

class ContainerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get container_index_url
    assert_response :success
  end

end
