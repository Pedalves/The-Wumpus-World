using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wumpus : MonoBehaviour, CellEffect
{
    public int DamagePoints;

    private int Health;

    // Use this for initialization
    void Start ()
    {
        Health = 100;
	}

    public void Action()
    {
        GM.GetInstance().GetAgent().ReceiveDamage(DamagePoints, true);
    }

    public void Interact()
    {

    }

    public void Damage(int damage)
    {
        Health -= damage;

        if (Health <= 0)
        {
            Vector2 tmp = transform.parent.gameObject.GetComponent<Cell>().Pos;
            Debug.Log("Wumpus died at [" + tmp.x + "," + tmp.y + "]");
            GM.GetInstance().GetAgent().Perceive("Scream");

            Destroy(gameObject);
        }
    }
}
