
require 'selenium-webdriver'

class CheckReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_request_id)
    reservation = ReservationRequest.find(reservation_request_id)

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')

    driver = Selenium::WebDriver.for :chrome, options: options

    begin

      driver.get("https://reserve.tokyodisneyresort.jp/top/")
      sleep(3)


      driver.find_element(:xpath, "//img[@src='/cgp/images/jp/pc/btn/btn_gn_04.png']").click
      sleep(3)


      driver.find_element(:xpath, "//img[@src='/cgp/images/jp/pc/btn/btn_close_08.png']").click
      driver.implicitly_wait(3)


      driver.find_element(:id, 'searchUseDateDisp').send_keys(reservation.date.strftime('%Y/%m/%d'))


      select_element = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'searchAdultNum'))
      select_element.select_by(:value, reservation.party_size.to_s)


      select_element = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'nameCd'))
      select_element.select_by(:value, reservation.restaurant_id)


      driver.find_element(:xpath, "//input[@src='/cgp/images/jp/pc/btn/btn_search_01.png']").click
      sleep(3)


      driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
      sleep(3)


      if driver.find_element(:id, 'hasNotResultDiv').text.include?("お探しの条件で、空きはございません。")
        Rails.logger.info("予約空きなし")
      else
        Rails.logger.info("空きが見つかりました")

        ReservationMailer.availability_notification(reservation.user, reservation).deliver_later
      end

    ensure
      driver.quit
    end
  end
end
