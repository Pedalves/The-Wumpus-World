using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle : MonoBehaviour, CellEffect
{
	// Use this for initialization
	void Start ()
    {
		
	}

    public void Action()
    {
        GM.GetInstance().GetAgent().ReceiveDamage(1000);
    }

    public void Interact()
    {

    }
}
