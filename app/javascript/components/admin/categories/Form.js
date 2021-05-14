import React, { useState } from 'react';
import { Button, Modal, Form, Input, Radio, message } from 'antd';

const CollectionCreateForm = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();
  return (
    <Modal
      visible={visible}
      title="Create a new category"
      okText="Create"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form
          .validateFields()
          .then((values) => {
            form.resetFields();
            onCreate(values);
          })
          .catch((info) => {
            console.log('Validate Failed:', info);
          });
      }}
    >
      <Form
        form={form}
        layout="vertical"
        name="form_in_modal"
        initialValues={{
          active: 'false',
        }}
      >
        <Form.Item
          name="title"
          label="Title"
          rules={[
            {
              required: true
            },
          ]}
        >
          <Input />
        </Form.Item>
        <Form.Item name="active" className="collection-create-form_last-form-item">
          <Radio.Group>
            <Radio value="false">Draft</Radio>
            <Radio value="trie">Published</Radio>
          </Radio.Group>
        </Form.Item>
      </Form>
    </Modal>
  );
};

const CollectionsPage = ({onCategoryUpdated}) => {
  const [visible, setVisible] = useState(false);

  const onCreate = (values) => {
    setVisible(false);
    const {title, active} = values;

    const url = '/admin/categories.json';
    const data = { category: { title, active } }

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    }).then(response => response.json())
    .then(data => {
      message.info("Category was created")
      if (onCategoryUpdated) {
        onCategoryUpdated(data)
      }
    });
  };

  return (
    <div>
      <Button
        type="primary"
        onClick={() => {
          setVisible(true);
        }}
      >
        New Category
      </Button>
      <CollectionCreateForm
        visible={visible}
        onCreate={onCreate}
        onCancel={() => {
          setVisible(false);
        }}
      />
    </div>
  );
};

export default CollectionsPage
