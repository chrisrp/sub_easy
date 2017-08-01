require 'digest/md5'

  EXTENSIONS = 'avi,mkv,mp4,mov,mpg,wmv,rm,rmvb,divx'

  def baixa_tudo(language = 'pt')
    list_files(Dir.pwd).each do |file|
      next unless subtitle?(file)

      subtitle = download_subtitle(file)
      #chupinha(subtitle)
    end
  end

  def list_files(entry_point)
    Dir["#{entry_point}/**/*.{#{EXTENSIONS}}"]
  end

  def subtitle?(path, language)
    dir = File.dirname(path)

    Dir["#{dir}/#{File.basename(path, '.*')}.#{language}.{srt,sub}"].any?
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
