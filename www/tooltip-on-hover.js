function (data, type, row, meta) {
  if (type === 'display') {
    col_num = meta['col']
    return '<span title="' + row[col_num] + '">' + data + '</span>';
  }
  return data;
}
