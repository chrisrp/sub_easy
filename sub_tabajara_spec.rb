require 'rspec'
require_relative 'sub_tabajara'

RSpec.describe 'Modulo Tabajara' do
  describe '#list_files' do
    it 'lists files from path' do
      expect(list_files(Dir.pwd).size).to eq(2)
    end
  end

  describe '#subtitle?' do
    context 'when file exists' do
      it 'returns true' do
        file_path = File.join(Dir.pwd, 'test_files', 'file1.mkv')

        expect(subtitle?(file_path, 'pt')).to be_truthy
      end
    end

    context 'when file do not exist' do
      it 'returns false' do
        file_path = File.join(Dir.pwd, 'test_files', 'file2.avi')

        expect(subtitle?(file_path, 'pt')).to be_falsey
      end
    end
  end
end
