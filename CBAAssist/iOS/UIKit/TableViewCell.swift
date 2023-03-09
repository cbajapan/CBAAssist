//
//  TableViewCell.swift
//  CBAAssist
//
//  Created by Cole M on 10/19/22.
//

import UIKit

struct RowData {
    
    var indexPath: IndexPath
    var text: String
    var toggle = false
    var slider: Float = 0.0

    init(indexPath: IndexPath, text: String, toggle: Bool, slider: Float) {
        self.indexPath = indexPath
        self.text = text
        self.slider = slider
        self.toggle = toggle
    }
}

class TableRow: UITableViewCell {
    
    var singleSwitch: UISwitch = {
        let s = UISwitch()
        s.tag = SWITCH_ID_TAG
        return s
    }()
    
    var singleLabel: UILabel = {
        let s = UILabel()
        s.tag = LABEL_ID_TAG
        return s
    }()
    
    var singleTextField: UITextField = {
        let s = UITextField()
        s.placeholder = "Text Field"
        s.tag = TXT_ID_TAG
        return s
    }()
    
    var singleSlider: UISlider = {
        let s = UISlider()
        s.tag = SLIDER_ID_TAG
        return s
    }()

    var rows = [RowData]()
    var currentIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        singleLabel.translatesAutoresizingMaskIntoConstraints = false
        singleTextField.translatesAutoresizingMaskIntoConstraints = false
        singleSwitch.translatesAutoresizingMaskIntoConstraints = false
        singleSlider.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(singleLabel)
        contentView.addSubview(singleTextField)
        contentView.addSubview(singleSwitch)
        contentView.addSubview(singleSlider)
        
        singleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        singleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        singleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        singleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true

        singleTextField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        singleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        singleTextField.leadingAnchor.constraint(equalTo: singleLabel.trailingAnchor).isActive = true
        singleTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true

        singleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        singleSwitch.leadingAnchor.constraint(equalTo: singleTextField.trailingAnchor).isActive = true
        singleSwitch.widthAnchor.constraint(equalToConstant: 100).isActive = true

        singleSlider.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        singleSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        singleSlider.leadingAnchor.constraint(equalTo: singleSwitch.trailingAnchor).isActive = true
        singleSlider.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadRowData(indexPath: IndexPath, items: Int) {
        currentIndexPath = indexPath

        let tf = contentView.viewWithTag(TXT_ID_TAG) as? UITextField
        let sw = contentView.viewWithTag(SWITCH_ID_TAG) as? UISwitch
        let slider = contentView.viewWithTag(SLIDER_ID_TAG) as? UISlider
        let label = contentView.viewWithTag(LABEL_ID_TAG) as? UILabel
        let labTxt = "\(indexPath.section * items + indexPath.row)"
        
        label?.text = labTxt
        tf?.accessibilityLabel = labTxt

        let populate = rows.first(where: { $0.indexPath == indexPath })
        
        if let populate {
            tf?.text = populate.text
            sw?.isOn = populate.toggle
            slider?.value = populate.slider
        } else {
            tf?.text = ""
            sw?.isOn = true
            slider?.value = 0.5
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let tf = contentView.viewWithTag(TXT_ID_TAG) as? UITextField else { return }
        guard let sw = contentView.viewWithTag(SWITCH_ID_TAG) as? UISwitch else { return }
        guard let slider = contentView.viewWithTag(SLIDER_ID_TAG) as? UISlider else { return }
        guard let path = currentIndexPath else { return }
        guard let text = tf.text else { return }
        let rowToUpdate = RowData(indexPath: path, text: text, toggle: sw.isOn, slider: slider.value)
        rows.append(rowToUpdate)
    }
    
}





