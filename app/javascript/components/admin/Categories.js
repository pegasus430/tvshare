import { Layout, Menu, Breadcrumb, Sider } from 'antd';
import Form from "./categories/Form";
import Shows from "./categories/Shows";
import CategorySorter from "./categories/CategorySorter";
import {useState, useEffect} from "react";
import { Button, Space } from 'antd';

const { Header, Content, Footer } = Layout;

const Categories= () => {
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);

  useEffect(() => {
   getCategories().then(categories => {
     setCategories(categories)
   })
}, [selectedCategory])

  const updateCategories = (_categories) => {
    setCategories(_categories);
    _categories.forEach((category, i) => {
      const url = `/admin/categories/${category.id}.json`;
      const data = { category: { position: i } }

      fetch(url, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      }).then(response => response.json())
      .then(data => {
      });
    })
  }

  return (
    <Layout className="layout">
      <Header>
        <div className="logo" />
        <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['home']}>
          <Menu.Item key="home" onClick={() => setSelectedCategory(null) }>All Categories</Menu.Item>
          <Menu.Item key="form"><Form onCategoryUpdated={(category) => {setSelectedCategory(category)}}/></Menu.Item>
          {categories.map((category, i) => {
            return <Menu.Item key={i} onClick={() => setSelectedCategory(category)}>{category.title}</Menu.Item>
          })}
        </Menu>
      </Header>
      <Content style={{ padding: '0 50px' }}>
        <div className="site-layout-content">{selectedCategory ? <Shows category={selectedCategory} onDelete={() => setSelectedCategory(null) }/> : <CategorySorter list={categories} onChange={(values) => { updateCategories(values) }} />}</div>
      </Content>
      <Footer style={{ textAlign: 'center' }}>TV Chat</Footer>
    </Layout>
  );
}

export default Categories;

function getCategories() {
  return fetch('/admin/categories.json')
    .then(data => data.json())
}
