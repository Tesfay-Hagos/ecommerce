package models

import (
	"context"
	"database/sql"
	"time"
)

type DBModel struct {
	DB *sql.DB
}

type Models struct {
	DB DBModel
}

// NewModels returns a model type with database connection pool
func NewModels(db *sql.DB) Models {
	return Models{
		DB: DBModel{
			DB: db,
		},
	}
}

type Widget struct {
	ID             int    `json:"id"`
	Name           string `json:"name"`
	Description    string `json:"description"`
	InventoryLevel int    `json:"inventory_level"`
	Price          int    `json:"price"`
	CreatedAt      string `json:"created_at"`
	UpdatedAt      string `json:"updated_at"`
}

func (m *DBModel) GetWidget(id int) (Widget, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	var widget Widget
	row := m.DB.QueryRowContext(ctx, "select id,name from widgets where id=?", id)
	err := row.Scan(&widget.ID, &widget.Name)
	if err != nil {
		return widget, err
	}
	return widget, nil
}
