# encoding: utf-8

require 'spec_helper'

describe 'user with a book' do
  let(:organizer) { create(:organizer) }
  let(:book) { organizer.organized_books.first }

  before do
    visit root_path
    click_link('Entrar no site')
    fill_in 'signin_email', :with => organizer.email
    fill_in 'signin_password', :with => organizer.password
    click_button 'Entrar'
    click_link 'Meus Livros'
    click_link book.title
  end

  context 'when starting a new project' do
    it 'sees the book info' do
      page.should have_content(book.title)
      page.should have_xpath("//nav[@class='book-nav']")
    end

    it 'clicks the new project link' do
      click_link 'Criar projeto'
      current_path.should eq(new_project_path)
    end
  end
end