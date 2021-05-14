import React, { FC, useState } from "react";
import { ReactSortable } from "react-sortablejs";
import { List, Typography, Divider } from 'antd';

const SortableList = ({list, onChange}) => {
  const style = {padding: "2em", fontSize: "2em", border: '1px  solid rgba(0,0,0,0.5', textAlign: 'center', marginTop: "1em" }

  return (
    <>
      <Divider>Category Order</Divider>
      <ReactSortable list={list} setList={onChange}>
        {list.map((item) => (
          <div key={item.id} style={{...style, background: item.active ? 'rgba(0, 141, 255, 0.2)' : 'rgba(0, 0, 0, 0.2)' }}>{item.title}</div>
        ))}
      </ReactSortable>
    </>
  );
};

export default SortableList;
