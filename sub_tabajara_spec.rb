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

  describe '#download_available?' do
    let(:url) do
      'http://api.thesubdb.com/?action=search&hash=edc1981d6459c6111fe36205b4aff6c2'
    end
    let(:user_agent) do
      'SubDB/1.0 (tabajara_cli/0.1; http://example.tabajara.com)'
    end

    context 'when there is a subtitle' do
      it 'returns true' do
        response = double('response', code: '200', body: 'pt,en,es')
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(response)

        result = download_available? File.join(Dir.pwd, 'test_files', 'file1.mkv'), 'pt'
        expect(result).to be_truthy
      end
    end

    context 'when there is NOT a subtitle' do
      it 'checks if subtitle is available' do
        response = double('response', code: '200', body: 'pt,en,es')
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(response)

        result = download_available? File.join(Dir.pwd, 'test_files', 'file1.mkv'), 'md'
        expect(result).to be_falsey
      end
    end

    describe '#download_subtitle' do
      xit 'download the file' do
        "c22a04b1a502e16c32614c73c34306eb"
      end
    end

    describe '#sub_name_for_file' do
      it 'returns the subtitle file name' do
        file_name = File.join(Dir.pwd, 'test_files', 'file1.mkv')
        sub_name  = File.join(Dir.pwd, 'test_files', 'file1.pt.srt')
        expect(sub_name_for_file(file_name, 'pt')).to eq(sub_name)
      end

    end
  end
end
