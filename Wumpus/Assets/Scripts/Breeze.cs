using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Breeze : MonoBehaviour, CellEffect
{
    // Use this for initialization
	void Start ()
    {
		
	}
    
    public void Action()
    {
        GM.GetInstance().GetAgent().Perceive("Breeze");
    }
}
