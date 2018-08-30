ShowDiffJob = Struct.new(:other_tree, :file_name ) do
  def before
    Flexite::JobReport.create(file_name: file_name, status: Flexite::JobReport::STATUS[:in_progress])
  end

  def perform
    Flexite::Diff::CheckService.new(other_tree, file_name).call
  end

  def success
    Flexite::JobReport
      .find_by_file_name(file_name)
      .update_attributes(status: Flexite::JobReport::STATUS[:done])
  end

  def error
    Flexite::JobReport
      .find_by_file_name(file_name)
      .update_attributes(status: Flexite::JobReport::STATUS[:error])
  end
end
