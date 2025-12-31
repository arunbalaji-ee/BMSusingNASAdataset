function row = get_metadata_row(meta, filename)

    idx = strcmp(meta.filename, filename);
    row = meta(idx,:);

end
