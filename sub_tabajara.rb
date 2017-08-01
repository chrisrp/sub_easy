require 'digest/md5'
require 'net/http'

  EXTENSIONS = 'avi,mkv,mp4,mov,mpg,wmv,rm,rmvb,divx'

  def agent
    'SubDB/1.0 (tabajara_cli/0.1; http://example.tabajara.com)'
  end

  def download_subtitle(file, language)
    uri = URI("http://api.thesubdb.com/?action=download&hash=#{build_hash(file)}&language=#{language}")
    req = Net::HTTP::Get.new(uri)
    req['User-Agent'] = agent

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    res.body if res.code == '200'
  end

  def download_available?(file, language)
    uri = URI("http://api.thesubdb.com/?action=search&hash=#{build_hash(file)}")
    req = Net::HTTP::Get.new(uri)
    req['User-Agent'] = agent

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    res.body.split(',').include?(language) if res.code == '200'
  end

  def baixa_1(file, language='pt')
    return unless subtitle?(file)

      if download_available?(file, language)
        sub_file_name = sub_name_for_file(file, language)

        subtitle = download_subtitle(file)
        File.open(sub_file_name, 'w') { |f| f.write(subtitle) }
      end
  end

  def baixa_tudo(language = 'pt')
    list_files(Dir.pwd).each do |file|
      next unless subtitle?(file)

      if download_available?(file, language)
        sub_file_name = sub_name_for_file(file, language)

        subtitle = download_subtitle(file)
        File.open(sub_file_name, 'w') { |f| f.write(subtitle) }
      end
    end
  end

  def list_files(entry_point)
    Dir["#{entry_point}/**/*.{#{EXTENSIONS}}"]
  end

  def subtitle?(path, language)
    dir = File.dirname(path)

    Dir["#{dir}/#{File.basename(path, '.*')}.#{language}.{srt,sub}"].any?
  end

  def sub_name_for_file(file, language)
    dir = File.dirname(file)
    "#{dir}/#{File.basename(file, '.*')}.#{language}.srt"
  end

  def build_hash(path)
    chunk_size = 64 * 1024

    size = File.size(path)

    raise ArgumentError.new("The video file need to have at least 128kb") if size < chunk_size * 2

    file = File.open(path, 'rb')
    data = file.read(chunk_size)
    file.seek(size - chunk_size)
    data += file.read(chunk_size)

    file.close

    Digest::MD5.hexdigest(data)
  end
